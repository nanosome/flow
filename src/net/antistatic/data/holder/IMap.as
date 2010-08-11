package net.antistatic.data.holder
{
	
import net.antistatic.data.holder.IIterator;

/**
 * {@code Map} is the base interface for data holders that map keys to values.
 * 
 * <p>A map offers two methods that help you find out whether it contains a specific
 * key or value. These two methods are {@link #containsKey} and {@link #containsValue}.
 * 
 * <p>To get the data stored in the map you can use the methods {@link #getKeys},
 * {@link #getValues} and {@link #get}. If you want to iterate over the values of
 * the map you can use the iterators returned by the methods {@link #iterator} or
 * {@link #valueIterator}. If you want to iterate over the keys you can use the
 * iterator returned by the {@link #keyIterator} method.
 *
 * <p>To add key value pairs to the map you can use the methods {@link #put} and
 * {@link #putAll}. The {@code putAll} method lets you add all key-value pairs
 * contained in the passed-in {@code map} to this map.
 * 
 * <p>To remove key-value pairs you can use the methods {@link #remove} and
 * {@link #clear}. The {@code remove} method deletes only the key-value pair
 * corresponding to the passed-in {@code key}, while the clear method removes all
 * key-value pairs.
 *
 * <p>There are two more methods you may need. The {@link #isEmpty} and the
 * {@link #size} method. These methods give you information about whether this
 * map contains any mappings and how many mappings it contains.
 *
 * <p>Example:
 * <code>
 *   // the map gets set up somewhere
 *   var map:Map = new MyMap();
 *   map.put("myKey", "myValue");
 *   // at some different place in your code
 *   if (map.containsKey("myKey")) {
 *       trace(map.get("myKey"));
 *   }
 * </code>
 *
 * @author Simon Wacker
 * @author Michael Herrmann
 */
public interface IMap {
	
	/**
	 * Checks if the passed-in {@code key} exists.
	 *
	 * <p>That means whether a value has been mapped to it.
	 *
	 * @param key the key to be checked for availability
	 * @return {@code true} if the {@code key} exists else {@code false}
	 */
	function containsKey(key:*):Boolean;
	
	/**
	 * Checks if the passed-in {@code value} is mapped to a key.
	 * 
	 * @param value the value to be checked for availability
	 * @return {@code true} if the {@code value} is mapped to a key else {@code false}
	 */
	function containsValue(value:*):Boolean;
	
	/**
	 * Returns an array that contains all keys that have a value mapped to
	 * it.
	 *
	 * @return an array that contains all keys
	 */
	function getKeys():Array;
	
	/**
	 * Returns an array that contains all values that are mapped to a key.
	 *
	 * @return an array that contains all mapped values
	 */
	function getValues():Array;
	
	/**
	 * Returns the value that is mapped to the passed-in {@code key}.
	 * 
	 * @param key the key to return the corresponding value for
	 * @return the value corresponding to the passed-in {@code key}
	 */
	function get(key:*):*;
	
	/**
	 * Maps the given {@code key} to the {@code value}.
	 *
	 * @param key the key used as identifier for the {@code value}
	 * @param value the value to map to the {@code key}
	 * @return the value that was originally mapped to the {@code key}
	 */
	function put(key:*, value:*):*;
	
	/**
	 * Copies all mappings from the passed-in {@code map} to this map.
	 *
	 * @param map the mappings to add to this map
	 */
	function putAll(map:IMap):void;
	
	/**
	 * Removes the mapping from the given {@code key} to the value.
	 *
	 * @param key the key identifying the mapping to remove
	 * @return the value that was originally mapped to the {@code key}
	 */
	function remove(key:*):*;
	
	/**
	 * Clears all mappings.
	 */
	function clear():void;
	
	/**
	 * Returns an iterator to iterate over the values of this map.
	 *
	 * @return an iterator to iterate over the values of this map
	 * @see #valueIterator
	 * @see #getValues
	 */
	function iterator():IIterator;
	
	/**
	 * Returns an iterator to iterate over the values of this map.
	 *
	 * @return an iterator to iterate over the values of this map
	 * @see #iterator
	 * @see #getValues
	 */
	function valueIterator():IIterator;
	
	/**
	 * Returns an iterator to iterate over the keys of this map.
	 *
	 * @return an iterator to iterate over the keys of this map
	 * @see #getKeys
	 */
	function keyIterator():IIterator;
	
	/**
	 * Returns the amount of mappings.
	 *
	 * @return the amount of mappings
	 */
	function size():uint;
	
	/**
	 * Returns whether this map contains any mappings.
	 * 
	 * @return {@code true} if this map contains any mappings else {@code false}
	 */
	function isEmpty():Boolean;
	
}

}