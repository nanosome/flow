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

package net.antistatic.data.holder.array
{
	
import net.antistatic.data.holder.IIterator;

/**
 * {@code ArrayIterator} can be used to iterate over arrays.
 *
 * <p>The usage of this iterator is quite simple. There is one method to check
 * whether there are more elements left to iterate over {@link #hasNext}, one method
 * to get the next element {@link #next} and one to remove the current element
 * {@link #remove}.
 * 
 * <p>Example:
 * <code>
 *   var iterator:Iterator = new ArrayIterator(["value1", "value2", "value3"]);
 *   while (iterator.hasNext()) {
 *       trace(iterator.next());
 *   }
 * </code>
 * <p>Output:
 * <pre>
 *   value1
 *   value2
 *   value3
 * </pre>
 *
 * @author Simon Wacker
 * @author Michael Herrmann
 * @author Martin Heidegger
 */
public class ArrayIterator implements IIterator {
	
	/** The target data holder. */
	private var t:Array;
	
	/** The current index of the iteration. */
	private var i:int;
	
	/**
	 * Constructs a new {@code ArrayIterator} instance.
	 * 
	 * @param target the array to iterate over
	 * @throws IllegalArgumentException if the passed-in {@code target} array is
	 * {@code null} or {@code undefined}
	 */
	public function ArrayIterator(target:Array) {
		// Exception if the passed array is not available.
		if (!target) throw new ArgumentError("Argument 'target' [" + target + "] must not be 'null' nor 'undefined'.");

		// Usual handling of the arguments.
		this.t = target;
		i = -1;
	}
	
	/**
	 * Returns whether there exists another element to iterate over.
	 * 
	 * @return {@code true} if there is at least one lement left to iterate over
	 */
	public function hasNext():Boolean {
		return (i < t.length-1);
	}
	
	/**
	 * Returns the next element of the array.
	 * 
	 * @return the next element of the array
	 * @throws NoSuchElementException if there is no next element
	 */
	public function next():* {
		if (!hasNext()) {
			throw new Error("There is no more element.");
		}
		return t[++i];
	}
	
	/**
	 * Removes the currently selected element from this iterator and from the array this
	 * iterator iterates over.
	 * 
	 * @throws IllegalStateException if you try to remove an element when none is selected
	 */
	public function remove():void {
		if (i < 0) {
			throw new Error("You tried to remove an element before calling the 'next' method. There is thus no element selected to remove.");
		}
		t.splice(i--, 1);
	}
	
}
}