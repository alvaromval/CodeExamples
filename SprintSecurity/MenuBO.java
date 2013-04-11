package com.ferrovial.phoenix.generic.bo;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.xml.datatype.DatatypeConfigurationException;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.ferrovial.phoenix.common.exception.PhoenixBusinessException;
import com.ferrovial.phoenix.common.model.Tgenfunctionality;
import com.ferrovial.phoenix.common.model.Tgenmenuitem;
import com.ferrovial.phoenix.generic.bo.inter.IMenuBO;
import com.ferrovial.phoenix.generic.dao.inter.IMenuDAO;
import com.ferrovial.phoenix.generic.util.MenuAssembler;
import com.ferrovial.phoenix.generic.vo.MenuItemVO;
import com.ferrovial.phoenix.generic.vo.io.GetMenuItemRequestVO;
import com.ferrovial.phoenix.generic.vo.io.GetMenuItemResponseVO;
import com.ferrovial.phoenix.security.bo.inter.ISecurityService;
import com.ferrovial.phoenix.security.dao.inter.IFunctionalityDAO;
import com.ferrovial.phoenix.security.vo.FunctionalityProfileAccessVO;
import com.ferrovial.phoenix.security.vo.io.GetUserAccessByErpNodeRequestVO;
import com.ferrovial.phoenix.security.vo.io.GetUserAccessByErpNodeResponseVO;

/**
 * Clase genérica de negocio que tiene las operaciones de obtención y tratamiento del menu principal de la aplicación.
 * 
 * @author Álvaro Martínez del Val
 * @version 1.0
 */
@Transactional(rollbackFor = { Exception.class, PhoenixBusinessException.class })
public class MenuBO implements IMenuBO {
	/**
	* 
	*/
	private IMenuDAO menuDAO;
	/**
	 * 
	 */
     private  IFunctionalityDAO functionalityDAO;
     /**
      * 
      */
	private ISecurityService securityService;
  
public void setSecurityService(ISecurityService securityService) {
		this.securityService = securityService;
	}

public void setFunctionalityDAO(IFunctionalityDAO functionalityDAO) {
		this.functionalityDAO = functionalityDAO;
	}

	
	/**
	 * 
	 */
	private static final Logger LOGGER = Logger.getLogger(MenuBO.class);

	/**
	 * @param getMenuItemRequestVO .
	 *            
	 * @throws Exception .
	 * @return MenuItemVO
	 * @throws DatatypeConfigurationException  .
	 * @throws PhoenixBusinessException .
	 */
	public final GetMenuItemResponseVO getMainMenu(GetMenuItemRequestVO getMenuItemRequestVO)
			throws PhoenixBusinessException, DatatypeConfigurationException {
		LOGGER.debug("getMainMenu");
		final GetUserAccessByErpNodeRequestVO getUserAccessByErpNode = new GetUserAccessByErpNodeRequestVO();
		getUserAccessByErpNode.setHeaderVO(getMenuItemRequestVO.getHeaderVO());
		getUserAccessByErpNode.setErpNode(getMenuItemRequestVO.getErpNode());
		getUserAccessByErpNode.getHeaderVO().setIdLanguage(getMenuItemRequestVO.getHeaderVO().getIdLanguage());
		getUserAccessByErpNode.setIdHierarchy(getMenuItemRequestVO.getIdHierarchy());
		getUserAccessByErpNode.setIdApplication(getMenuItemRequestVO.getIdApplication());
		getUserAccessByErpNode.setIsProject(Boolean.FALSE);
		
		getUserAccessByErpNode.setIdUser(getMenuItemRequestVO.getHeaderVO().getIdUser());
		final GetUserAccessByErpNodeResponseVO  respuesta = securityService.getUserAccessByErpNode(getUserAccessByErpNode);		
		
		// AMV lista de puntos de menú sin permisos
		final Set<Tgenmenuitem> noPermissionsMenuItemList = new HashSet<Tgenmenuitem>();
		
		for (FunctionalityProfileAccessVO functionalityProfileAccessVO : respuesta.getFunctionalityProfileAccesVO()) {			
			Tgenfunctionality salida = functionalityDAO.findbyid(functionalityProfileAccessVO.getIdFunctionality());
			if(functionalityProfileAccessVO.getIdAccessType().equals("-"))
			{
				noPermissionsMenuItemList.addAll(salida.getTgenmenuitems());
			}
		}
		
		final List<Tgenmenuitem> lGenMenuItem = this.menuDAO.getMainMenu();
		final List<MenuItemVO> lMenuItemVO = MenuAssembler.getMenuItemVOFromListArray(lGenMenuItem);	
		
		for (MenuItemVO menuItem : lMenuItemVO) {
			hasMenuItem(menuItem, noPermissionsMenuItemList);
		}

		final GetMenuItemResponseVO response = new GetMenuItemResponseVO();
		response.setMenuItemlist(lMenuItemVO);
		//JMC: se devuelve la lista de funcionalidad para que en una sola llamada
		//se devuelva la lista de funcionalidad y el menu, asi evitamos recorrer dos
		//veces el árbol.
		
		response.setFunctionalityProfileAccesVO(respuesta.getFunctionalityProfileAccesVO());
		response.setIdProject(respuesta.getIdProject());
		return response;
	}

	/**
	 * 
	 * @param menuItem .
	 * @param funcmenuitems .
	 */
	private void hasMenuItem(MenuItemVO menuItem, Set<Tgenmenuitem> noPermissionsMenuItems)
	{	
		menuItem.setVisible(false);
		if(menuItem.getTgenmenuitems() == null || menuItem.getTgenmenuitems().size() == 0)
		{
			Boolean found = false;
			for(Tgenmenuitem tgenmenuitem : noPermissionsMenuItems)
			{
				if(menuItem.getIdmenuitem() == tgenmenuitem.getIdmenuitem())
				{
					found = true;
				}
			}
			if(!found)
			{
				menuItem.setVisible(true);
			}
		}
		else
		{
			for(MenuItemVO menuItem2 : menuItem.getTgenmenuitems())
			{
				hasMenuItem(menuItem2, noPermissionsMenuItems);
				if(menuItem2.getVisible())
				{
					menuItem.setVisible(true);
				}
			}
		}
	}

	public void setMenuDAO(IMenuDAO menuDAO) {
		this.menuDAO = menuDAO;
	}

}
