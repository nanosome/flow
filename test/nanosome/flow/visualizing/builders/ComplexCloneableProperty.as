// @license@
package nanosome.flow.visualizing.builders
{
    import nanosome.flow.ICloneable;
    import nanosome.flow.IComparable;

    public class ComplexCloneableProperty implements ICloneable, IComparable
    {
        internal var _paramOne:Number;
        internal var _paramTwo:String;

        public function ComplexCloneableProperty(paramOne:Number, paramTwo:String)
        {
            _paramOne = paramOne;
            _paramTwo = paramTwo;
        }

        public function clone():ICloneable
        {
            return new ComplexCloneableProperty(_paramOne, _paramTwo);
        }

        public function isEqualTo(value:IComparable):Boolean
        {
            var v:ComplexCloneableProperty = ComplexCloneableProperty(value);
            return (_paramOne == v._paramOne && _paramTwo == v._paramTwo);
        }
    }
}
