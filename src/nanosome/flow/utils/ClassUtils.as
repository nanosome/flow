package nanosome.flow.utils
{
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    public class ClassUtils
    {
        /**
         * For given instance of some class, returns names of all its member variables of given type.
         *
         * @param targetClassInstance - Target instance to be inspected for variables.
         * @param variableType - Type of required variable. Strict checking with be used (i.e. no inheritance).
         * @return Vector of Strings, with names of member variables.
         */
        public static function getVariablesOfType(targetClassInstance:Object, variableType:Class):Vector.<String>
        {
            var result:Vector.<String> = new Vector.<String>();

            var variableClassName:String = getQualifiedClassName(variableType);
			var typeDesc:XML = describeType(targetClassInstance);

			var vars:XMLList = typeDesc.child("variable");

			var typeAttr:String;
			var nameAttr:String;

			for each (var item:XML in vars)
			{
				typeAttr = item.attribute("type");
				nameAttr = item.attribute("name");

                if (typeAttr == variableClassName)
                    result.push(nameAttr);
			}

            return result;
        }
    }
}
