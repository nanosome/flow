package net.antistatic.data.holder
{
	
/**
 * Iterator is used to iterate over data holders.
 *
 * <p>An iterator is quite simple to use. There is one method to check whether there
 * are more elements left to iterate over <code>hasNext</code>, one method to get the
 * next element <code>next</code> and one to remove the current element <code>remove</code>.
 * 
 * @example Code:
 * <listing version="3.0"> 
 *   var iterator:Iterator = new MyIterator("value1", "value2", "value3");
 *   while (iterator.hasNext()) 
 *   {
 *       trace(iterator.next());
 *   }
 * </listing> 
 *
 * Output:
 *  <listing version="3.0">
 *   value1
 *   value2
 *   value3
 * </listing>
 * 
 * @author Simon Wacker
 * @author Michael Herrmann
 */
public interface IIterator 
{
	
	/**
	 * Returns whether there is another element to iterate over.
	 * 
	 * @return <code>true</code> if there is at least one element 
	 * left to iterate over
	 */
	function hasNext():Boolean;
	
	/**
	 * Returns the next element.
	 * 
	 * @return the next element
	 * @throws Error if there is no next element
	 */
	function next():*;
	
	/**
	 * Removes the currently selected element from this iterator and from the data holder
	 * this iterator iterates over.
	 * 
	 * @throws Error if you try to remove an element when none is selected
	 * @throws Error if this method is not supported by the concrete implementation of this interface
	 */
	function remove():void;
}
	
}