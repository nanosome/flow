// @license@
package nanosome.flow.visualizing.controller
{
    import nanosome.flow.stateMachine.controller.*;
    import nanosome.flow.stateMachine.*;
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.visualizing.Visualizer;

    /**
     *
     */
    public class VisualizerController extends StateMachineController
	{

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @param initialState Initial state to start with
		 */			
		public function VisualizerController(stateMachine:StateMachine, signals:AbstractSignalSet)
		{
            super(stateMachine, signals);
		}

        public function addVisualizer(visualizer:Visualizer):void
        {

        }
	}
}
