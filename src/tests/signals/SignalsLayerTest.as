package tests.signals
{
    import nanosome.flow.signals.SignalEvent;

    import org.flexunit.Assert;

    public class SignalsLayerTest
    {
        private var _signalsSet:TestSignalsSet;
        private var _firedSignals:Array;

        [Before]
        public function setUpTestSignalsSet():void
        {
            _signalsSet =  new TestSignalsSet();
        }

        [Test]
        public function ImplicitSignalsInstantiationTest():void
        {
            Assert.assertNotNull(_signalsSet.signalA);
            Assert.assertNotNull(_signalsSet.signalB);
        }

        [Test]
        public function EventsFiringTest():void
        {
            _firedSignals = [];
            _signalsSet.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
            _signalsSet.signalB.fire();
            _signalsSet.signalA.fire();
            _signalsSet.signalA.fire();
            Assert.assertEquals(_firedSignals.length, 3);
            Assert.assertEquals(_firedSignals[0], _signalsSet.signalB.id);
            Assert.assertEquals(_firedSignals[1], _signalsSet.signalA.id);
            Assert.assertEquals(_firedSignals[2], _signalsSet.signalA.id);
        }

        private function onSignalFired(event:SignalEvent):void
        {
            _firedSignals.push(event.signalID);
        }

    }
}
