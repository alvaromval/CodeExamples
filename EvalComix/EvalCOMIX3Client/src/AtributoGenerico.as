package
{
	/**
	 * Clase que representa los atributos comunes de un atributo
	 */
	public class AtributoGenerico
	{
		private var index:int = -1;
		private var comentario:String = null;
		
		public function AtributoGenerico()
		{
		}
		
		public function setIndex(index:int):void
		{
			this.index = index;
		}
		
		public function getIndex():int
		{
			return this.index;
		}
		
		public function setComentario(comentario:String):void
		{
			this.comentario = comentario;
		}
		
		public function getComentario():String
		{
			return this.comentario;
		}

	}
}