package tests.builder
{
    import tests.*;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.controller.StateMachineController;

    import org.flexunit.Assert;

    import tests.builder.TestStateMachineBuildersFactory;
    import tests.misc.ButtonSignals;

    public class StateMachineBuilderTest
    {
        private var _smc:TestStateMachineBuilder;

        [Before]
        public function CreateBuildersAndStateMachines():void
        {
            var repository:TestStateMachineBuildersFactory; // you're free to do it via singleton/.getInstance
            repository = new TestStateMachineBuildersFactory();
            _smc = repository.testStateMachineBuilder;
        }

        [Test]
        public function isImplicitInstantiationOfBuildersWorking():void
        {
            Assert.assertNotNull(_smc);
        }

        [Test]
        public function currentlyInTheWorks():void
        {
            // alternatively, we can use new ButtonSignals(), but taking signals from _smc
            // helps us to validate types before compilation
            var signals:ButtonSignals = _smc.getNewSignalsSet();
            var sm:StateMachine = _smc.getStateMachine();

            var c:StateMachineController = new StateMachineController(sm, signals);

            Assert.assertNotNull(signals, sm, c);
            Assert.assertNotNull(_smc.normal, c.getCurrentState());
            Assert.assertNotNull(_smc.normal, c.getCurrentState());
            // Assert.assertEquals(c.getCurrentState().id, _smc.normal.id);

            signals.mouseOver.fire();
            Assert.assertEquals(_smc.overed.id, c.getCurrentState().id);
            signals.mouseDown.fire();
            Assert.assertEquals(_smc.pressed.id, c.getCurrentState().id);

        }

    }
}
