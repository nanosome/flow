package signals
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
        public function implicitSignalsInstantiation():void
        {
            Assert.assertNotNull(_signalsSet.signalA);
            Assert.assertNotNull(_signalsSet.signalB);
        }

        [Test]
        public function eventsFiring():void
        {
            _firedSignals = [];
            _signalsSet.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
            _signalsSet.signalB.fire();
            _signalsSet.signalA.fire();
            _signalsSet.signalA.fire();
            Assert.assertEquals(3, _firedSignals.length);
            Assert.assertEquals(_signalsSet.signalB.id, _firedSignals[0]);
            Assert.assertEquals(_signalsSet.signalA.id, _firedSignals[1]);
            Assert.assertEquals(_signalsSet.signalA.id, _firedSignals[2]);
        }

        private function onSignalFired(event:SignalEvent):void
        {
            _firedSignals.push(event.signalID);
        }

    }
}
