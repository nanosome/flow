/**
 * Created by ${PRODUCT_NAME}.
 * User: Dmitry
 * Date: 01.11.10
 * Time: 19:19
 * To change this template use File | Settings | File Templates.
 */
package nanosome.flow.visualizing
{
    import nanosome.flow.stateMachine.logic.Transition;

    public class EasingBuilder
    {
        public function EasingBuilder()
        {
        }

        public function forTransition(transition:Transition):EasingBuilder
        {
            return this;
        }

        public function and(transition:Transition):EasingBuilder
        {
            return this;
        }

        public function easing(easingFunction:Function):EasingBuilder
        {
            return this;
        }

        public function duration(value:Number):void
        {

        }

    }
}
