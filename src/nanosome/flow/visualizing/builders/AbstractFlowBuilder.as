package nanosome.flow.visualizing.builders
{
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.visualizing.TargetPropertyVisualizer;
    import nanosome.flow.visualizing.TargetPropertyVisualizerManager;

    public class AbstractFlowBuilder extends VisualMappingBuilder
    {
        public function visualize(target:Object, signalSet:AbstractSignalSet):void
        {
            var visManager:TargetPropertyVisualizerManager = new TargetPropertyVisualizerManager(
                _smBuilder.getStateMachine(), signalSet
            );

            var visualizer:TargetPropertyVisualizer;
            var instance:Object;
            var instanceName:String;
            var props:Vector.<String>;
            var propertyName:String;
            var i:int;
            var k:uint;

            // iterate over animation mapping storage and create appropriate visualizers,
            // adding them to visManager
            for each (instanceName in _namesMappings)
            {
                if (!target.hasOwnProperty(instanceName))
                    throw new Error("Can't access instance named '" + instanceName + "' of object " + target);
                instance = target[instanceName];
                if (!instance)
                    throw new Error("Instance '" + instanceName + "' of object " + target + " should not be null");

                props = _mappingsAndAnimatorsStorage.getAllRegisteredPropertiesFor(instanceName);
                for (i = 0, k = props.length; i < k; i++)
                {
                    propertyName = props[i];
                    if (!instance.hasOwnProperty(propertyName))
                        throw new Error("Can't access property '" + propertyName + "' of instance '" + instanceName + "' of object " + target);

                    visualizer = new TargetPropertyVisualizer(
                        _mappingsAndAnimatorsStorage.getMapping(instanceName, propertyName),
                        _mappingsAndAnimatorsStorage.getAnimatorClass(instanceName, propertyName),
                        instance, propertyName
                    );
                    visManager.addTargetPropertyVisualizer(visualizer);
                }
            }
        }

    }
}
