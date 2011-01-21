package stateMachine.builder
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.processor.StateMachineProcessor;

    import org.flexunit.Assert;

    import misc.ButtonSignals;

    public class StateMachineBuilderTest
    {
        private var _smc:TestStateMachineBuilder;

        [BeforeClass]
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
        public function builtStateMachineLogic():void
        {
            // alternatively, we can use new ButtonSignals(), but taking signals from _smc
            // helps us to validate types before compilation
            var signals:ButtonSignals = _smc.getNewSignalsSet();
            var sm:StateMachine = _smc.getStateMachine();

            var c:StateMachineProcessor = new StateMachineProcessor(sm, signals);

            Assert.assertNotNull(signals);
            Assert.assertNotNull(sm);
            Assert.assertNotNull(c);

            Assert.assertEquals(_smc.normal.id, c.getCurrentState().id);
            signals.mouseOver.fire();
            Assert.assertEquals(_smc.overed.id, c.getCurrentState().id);
            signals.mouseDown.fire();
            Assert.assertEquals(_smc.pressed.id, c.getCurrentState().id);
        }
    }
}
