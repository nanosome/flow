/**
 * Created by ${PRODUCT_NAME}.
 * User: Dmitry
 * Date: 01.11.10
 * Time: 19:17
 * To change this template use File | Settings | File Templates.
 */
package nanosome.flow.visualizing.vizualizations
{
    import flash.display.Sprite;

    public class AlphaVisualization implements IVisualization
    {
        private var _target:Sprite;

        public function AlphaVisualization(target:Sprite)
        {
            _target = target;
        }

        public function apply(value:Number):void
        {
            _target.alpha = value;
        }
    }
}
