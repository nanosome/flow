
package net.antistatic.data.holder.list
{
import net.antistatic.data.holder.IIterator;
import net.antistatic.data.holder.IList;

/**
 * {@code ListIterator} iterates over lists, that are instances of classes that
 * implement the {@link List} interface.
 * 
 * <p>An iterator is quite simple to use. There is one method to check whether there
 * are more elements left to iterate over {@link #hasNext}, one method to get the
 * next element {@link #next} and one to remove the current element {@link #remove}.
 * 
 * <p>Example:
 * <code>
 *   var list:List = new MyList();
 *   list.insert("value1");
 *   list.insert("value2");
 *   list.insert("value3");
 *   var iterator:Iterator = new ListIterator(list);
 *   while (iterator.hasNext()) {
 *       trace(iterator.next());
 *   }
 * </code>
 *
 * <p>Output:
 * <pre>
 *   value1
 *   value2
 *   value3
 * </pre>
 * 
 * @author Simon Wacker
 */
public class ListIterator implements IIterator {
	
	/** The target to iterate over. */
	private var target:IList;
	
	/** The current element index. */
	private var i:int;
	
	/**
	 * Constructs a new {@code ListIterator} instance.
	 * 
	 * @param target the list to iterate over
	 */
	public function ListIterator(target:IList) {
		if (!target) throw new ArgumentError("Argument 'target' [" + target + "] must not be 'null' nor 'undefined'.");
		this.target = target;
		this.i = -1;
	}
	
	/**
	 * Returns whether there is another element to iterate over.
	 * 
	 * @return {@code true} if there is at least one element left to iterate
	 * over
	 */
	public function hasNext():Boolean {
		return (this.i < this.target.size() - 1);
	}
	
	/**
	 * Returns the next element.
	 * 
	 * @return the next element
	 * @throws org.as2lib.data.holder.NoSuchElementException if there is no next element
	 */
	public function next():* {
		if (!hasNext()) {
			throw new Error("There is no more element.");
		}
		return this.target.get(++this.i);
	}
	
	/**
	 * Removes the currently selected element from this iterator and from the data holder
	 * this iterator iterates over.
	 * 
	 * @throws org.as2lib.env.except.IllegalStateException if you try to remove an element
	 * when none is selected
	 */
	public function remove():void {
		if (this.i < 0) {
			throw new ArgumentError("You tried to remove an element before calling the 'next' method. There is thus no element selected to remove.");
		}
		this.target.removeByIndex(this.i);
	}
	
}

}