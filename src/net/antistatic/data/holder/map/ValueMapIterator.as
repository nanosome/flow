/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.antistatic.data.holder.map
{
	
import net.antistatic.data.holder.IIterator;
import net.antistatic.data.holder.IMap;
import net.antistatic.data.holder.array.ArrayIterator;

/**
 * {@code ValueMapIterator} is used to iterate over the values of a map.
 * 
 * <p>This iterator is quite simple to use. There is one method to check whether
 * there are more elements left to iterate over {@link #hasNext}, one method to get
 * the next element {@link #next} and one to remove the current element {@link #remove}.
 *
 * <p>Example:
 * <code>
 *   var map:Map = new HashMap();
 *   map.put("key1", 1);
 *   map.put("key2", 2);
 *   map.put("key3", 3);
 *   var iterator:Iterator = new ValueMapIterator(map);
 *   while (iterator.hasNext()) {
 *       trace(iterator.next());
 *   }
 * </code>
 *
 * <p>You normally do not use this class directly, but obtain an iterator that
 * iterates over the values of a map using the {@link Map#valueIterator} method.
 * The returned iterator can, but does not have to be an instance of this class.
 * 
 * <p>Example:
 * <code>
 *   var map:Map = new HashMap();
 *   // ...
 *   var iterator:Iterator = map.valueIterator();
 *   // ...
 * </code>
 *
 * @author Simon Wacker
 * @author Michael Hermann
 */
public class ValueMapIterator implements IIterator {
	
	/** The target map to iterate over. */
	private var target:IMap;
	
	/** The iterator used as a helper. */
	private var iterator:ArrayIterator;
	
	/** The presently selected key. */
	private var key:*;
	
	/**
	 * Constructs a new {@code ValueMapIterator} instance.
	 * 
	 * @param target the map to iterate over
	 * @throws IllegalArgumentException if the passed-in {@code target} map is {@code null}
	 * or {@code undefined}
	 */
	public function ValueMapIterator(target:IMap) {
		if (!target) throw new ArgumentError("The passed-in target map '" + target + "' is not allowed to be null or undefined.");
		this.target = target;
		iterator = new ArrayIterator(target.getKeys());
	}
	
	/**
	 * Returns whether there exists another value to iterate over.
	 * 
	 * @return {@code true} if there is at least one value left to iterate over
	 */
	public function hasNext():Boolean {
		return iterator.hasNext();
	}
	
	/**
	 * Returns the next value.
	 * 
	 * @return the next value
	 * @throws org.as2lib.data.holder.NoSuchElementException if there is no next value
	 */
	public function next():* {
		key = iterator.next();
		return target.get(key);
	}
	
	/**
	 * Removes the currently selected key-value pair from this iterator and from the
	 * map this iterator iterates over.
	 * 
	 * @throws org.as2lib.env.except.IllegalStateException if you try to remove a
	 * key-value pair when none is selected
	 */
	public function remove():void {
		iterator.remove();
		target.remove(key);
	}
	
}

}