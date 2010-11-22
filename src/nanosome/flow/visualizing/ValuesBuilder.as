/**
 * Created by ${PRODUCT_NAME}.
 * User: Dmitry
 * Date: 01.11.10
 * Time: 19:20
 * To change this template use File | Settings | File Templates.
 */
package nanosome.flow.visualizing
{
    import nanosome.flow.stateMachine.logic.State;

    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class ValuesBuilder
    {
        public function ValuesBuilder(visualization:IVisualizerTransform)
        {
        }

        public function forState(state:State):ValuesBuilder
        {
            return this;
        }

        public function value(value:Number):void
        {

        }
    }
}
