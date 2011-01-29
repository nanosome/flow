package nanosome.flow.utils
{
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;

    public class ClassUtils
    {
        /**
         * For given instance of some class, returns names of all its member variables of given type.
         *
         * @param targetClassInstance - Target instance to be inspected for variables.
         * @param variableType - Type of required variable. Strict checking will be used (i.e. no inheritance).
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

        /**
         * Returns true, if <code>targetClass</code> is the same class or inherited from <code>requiredType</code>.
         *
         * @param targetClass - Class, whose hierarchy has to be checked.
         * @param requiredType - Type to be checked against.
         * @return True, if <code>targetClass</code> is the same class or inherited from <code>requiredType</code>. '
         *         False otherwise.
         */
        public static function isClassSameOrInheritedFrom(targetClass:Class, requiredType:Class):Boolean
        {
            // we could describeType function here, but Adobe recommends to use
            // getQualifiedClassName and getQualifiedSuperClassName for traversing hierarchy
            if (getQualifiedClassName(targetClass) == getQualifiedClassName(requiredType))
                return true;
            else if (getQualifiedSuperclassName(targetClass) == null)
                return false;
            else
                return isClassSameOrInheritedFrom(
                            getDefinitionByName(getQualifiedSuperclassName(targetClass)) as Class,
                            requiredType
                       );
        }

        /**
         * For given instance of some class, returns names of all its member variables of given type or
         * inherited from this given type.
         *
         * @param targetClassInstance - Target instance to be inspected for variables.
         * @param variableType - Type of required variable. Inheritance will be also checked.
         * @return Vector of Strings, with names of member variables.
         */
        public static function getVariablesOfTypeOrInherited(targetClassInstance:Object, variableType:Class):Vector.<String>
        {
            var result:Vector.<String> = new Vector.<String>();
            var typeDesc:XML = describeType(targetClassInstance);
            var vars:XMLList = typeDesc.child("variable");

            var typeAttr:String;
            var nameAttr:String;

            for each (var item:XML in vars)
            {
                typeAttr = item.attribute("type");
                nameAttr = item.attribute("name");

               if ( ClassUtils.isClassSameOrInheritedFrom(getDefinitionByName(typeAttr) as Class, variableType) )
                    result.push(nameAttr);
            }

            return result;
        }


        /**
         * For given class member name, returns its class.
         *
         * @param targetClassInstance - Target instance to be inspected for variables.
         * @param variableName - Type of required variable, which class will be returned.
         * @return Class of member of targetClass instance with name <code>variableName</code> or null,
         * if no public variable with this name was found.
         */
        public static function getClassForVariable(targetClassInstance:Object, variableName:String):Class
        {
            var typeDesc:XML = describeType(targetClassInstance);

            var vars:XMLList = typeDesc.child("variable");

            var typeAttr:String;
            var nameAttr:String;

            for each (var item:XML in vars)
            {
                typeAttr = item.attribute("type");
                nameAttr = item.attribute("name");

                if (variableName == nameAttr)
                    return getDefinitionByName(typeAttr) as Class;
            }

            return null;
        }

    }
}
