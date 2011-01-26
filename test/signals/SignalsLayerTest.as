package signals
{
    import nanosome.flow.signals.SignalEvent;

    import org.flexunit.Assert;

    public class SignalsLayerTest
    {
        private static var _signalsSet:TestSignalsSet;

        [BeforeClass]
        public static function setUpTestSignalsSet():void
        {
            _signalsSet =  new TestSignalsSet();
        }

        [Test]
        public function implicitSignalsInstantiation():void
        {
            Assert.assertNotNull(_signalsSet.signalA);
            Assert.assertNotNull(_signalsSet.signalB);
        }

        private var _firedSignals:Array;

        [Test]
        public function areEventsFiring():void
        {
            _firedSignals = [];
            _signalsSet.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
            _signalsSet.signalB.fire();
            _signalsSet.signalA.fire();
            _signalsSet.signalA.fire();

            Assert.assertEquals(
                "Number of fired signals",
                3, _firedSignals.length
            );

            Assert.assertEquals(
                "First fired signal",
                _signalsSet.signalB.id, _firedSignals[0]
            );

            Assert.assertEquals(
                "Second fired signal",
                _signalsSet.signalA.id, _firedSignals[1]
            );

            Assert.assertEquals(
                "Third fired signal",
                _signalsSet.signalA.id, _firedSignals[2]
            );
        }

        private function onSignalFired(event:SignalEvent):void
        {
            _firedSignals.push(event.signalID);
        }

    }
}
