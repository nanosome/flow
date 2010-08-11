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
 
package net.antistatic.data.holder 
{
import net.antistatic.data.holder.IIterator;

/**
 * <code>List</code> holds values by index. Each value has its unique index.
 * 
 * @example Code:
 * <listing version="3.0">
 *   var list:List = new MyList();
 *   list.insert("myValue1");
 *   list.insertFirst("myValue2");
 *   list.insertLast("myValue3");
 *   trace(list.contains("myValue2"));
 *   trace(list.remove(0));
 *   trace(list.contains("myValue2"));
 *   trace(list.removeLast());
 *   trace(list.get(0));
 *   list.clear();
 *   trace(list.size());
 * </listing>
 * 
 * Output:
 * <listing version="3.0">
 *   true
 *   myValue2
 *   false
 *   myValue3
 *   myValue1
 *   0
 * </listing version="3.0">
 * 
 * @author Simon Wacker
 */
public interface IList
{
	
	/**
	 * @overload #insertByValue
	 * @overload #insertByIndexAndValue
	 */
	function insert(...args):void;
	
	/**
	 * Inserts <code>value</code> at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insertLast()
	 */
	function insertByValue(value:*):void;
	
	/**
	 * Inserts <code>value</code> at the given <code>index</code>.
	 * 
	 * <p>The element that is currently at the given <code>index</code> is shifted by one to
	 * the right, as well as any subsequent elements.
	 * 
	 * @param index the index at which to insert the <code>value</code>
	 * @param value the value to insert
	 * @throws IndexOutOfBoundsException if the given <code>index</code> is not in range,
	 * this is less than 0 or greater than this list's size
	 */
	function insertByIndexAndValue(index:uint, value:*):void;
	
	/**
	 * Inserts <code>value</code> at the beginning of this list.
	 * 
	 * @param value the value to insert
	 */
	function insertFirst(value:*):void;
	
	/**
	 * Inserts <code>value</code> at the end of this list.
	 * 
	 * @param value the value to insert
	 * @see #insert
	 */
	function insertLast(value:*):void;
	
	/**
	 * @overload #insertAllByList()
	 * @overload #insertAllByIndexAndList()
	 */
	function insertAll():void;
	
	/**
	 * Inserts all values contained in <code>list</code> to the end of this list.
	 * 
	 * @param list the values to insert
	 */
	function insertAllByList(list:IList):void;
	
	/**
	 * Inserts all values contained in <code>list</code> to this list, starting at the
	 * specified <code>index</code>.
	 * 
	 * <p>Elements that are at an affected index are shifted to the right by the size
	 * of the given <code>list</code>.
	 * 
	 * @param index the index to start the insertion at
	 * @param list the values to insert
	 * @throws IndexOutOfBoundsException if the given <code>index</code> is not in range,
	 * this is less than 0 or greater than this list's size
	 */
	function insertAllByIndexAndList(index:uint, list:IList):void;
	
	/**
	 * @overload #removeByValue
	 * @overload #removeByIndex
	 */
	function remove(...args):*;
	
	/**
	 * Removes <code>value</code> from this list if it exists and returns the index of the
	 * removed element.
	 * 
	 * @param value the value to remove
	 * @return the index of the removed element or <code>-1</code> if it did not exist on
	 * this list
	 */
	function removeByValue(value:*):uint;
	
	/**
	 * Removes the value at given <code>index</code> from this list and returns it.
	 * 
	 * @param index the index of the value to remove
	 * @return the removed value that was originally at given <code>index</code>
	 * @throws IndexOutOfBoundsException if given <code>index</code> is less than 0 or
	 * equal to or greater than this list's size
	 */
	function removeByIndex(index:uint):*;
	
	/**
	 * Removes the value at the beginning of this list.
	 * 
	 * @return the removed value
	 */
	function removeFirst():*;
	
	/**
	 * Removes the value at the end of this list.
	 * 
	 * @return the removed value
	 */
	function removeLast():*;
	
	/**
	 * Removes all values contained in <code>list</code>.
	 * 
	 * @param list the values to remove
	 */
	function removeAll(list:IList):void;
	
	/**
	 * Sets <code>value</code> to given <code>index</code> on this list. The value that was
	 * originally at the given <code>index</code> will be overwritten.
	 * 
	 * @param index the index of <code>value</code>
	 * @param value the <code>value</code> to set to given <code>index</code>
	 * @return the value that was orignially at given <code>index</code>
	 * @throws IndexOutOfBoundsException if given <code>index</code> is less than 0 or
	 * equal to or greater than this list's size
	 */
	function set(index:uint, value:*):*;
	
	/**
	 * Sets all values contained in <code>list</code> to this list, starting from given
	 * <code>index</code>. They values that were originally at the given <code>index</code>
	 * and following indices will be overwritten.
	 * 
	 * <p>This method only overwrites existing index-value pairs. If an affected index
	 * is equal to or greater than this list's size, which would mean that this list's
	 * size had to be expanded, an <code>IndexOutOfBoundsException</code> will be thrown. In
	 * such a case use the <code>insertAll</code> method instead, which expands this list
	 * dynamically.</p>
	 * 
	 * @see insertAll
	 * @param index the index to start at
	 * @param list the values to set
	 * @throws IndexOutOfBoundsException if given <code>index</code> is less than 0 or if
	 * any affected index, that is the given <code>index</code> plus the index of the
	 * specific value in the given <code>list</code>, is equal to or greater than this list's
	 * size
	 */
	function setAll(index:uint, list:IList):void;
	
	/**
	 * Returns the value at given <code>index</code>.
	 * 
	 * @param index the index to return the value of
	 * @return the value that is at given <code>index</code>
	 * @throws IndexOutOfBoundsException if given <code>index</code> is less than 0 or
	 * equal to or greater than this list's size
	 */
	function get(index:uint):*;
	
	/**
	 * Checks whether <code>value</code> is contained in this list.
	 * 
	 * @param value the value to check whether it is contained
	 * @return <code>true</code> if <code>value</code> is contained else <code>false</code>
	 */
	function contains(value:*):Boolean;
	
	/**
	 * Checks whether all values of <code>list</code> are contained in this list.
	 * 
	 * @param list the values to check whether they are contained
	 * @return <code>true</code> if all values of <code>list</code> are contained else
	 * <code>false</code>
	 */
	function containsAll(list:IList):Boolean;
	
	/**
	 * Retains all values the are contained in <code>list</code> and removes all others.
	 * 
	 * @param list the list of values to retain
	 */
	function retainAll(list:IList):void;
	
	/**
	 * Returns a view of the portion of this list between the specified <code>fromIndex</code>,
	 * inclusive, and <code>toIndex</code>, exclusive.
	 * 
	 * <p>If <code>fromIndex</code> and <code>toIndex</code> are equal an empty list is returned.</p>
	 * 
	 * <p>The returned list is backed by this list, so changes in the returned list are
	 * reflected in this list, and vice-versa.</p>
	 * 
	 * @param fromIndex the index from which the sub-list starts (inclusive)
	 * @param toIndex the index specifying the end of the sub-list (exclusive)
	 * @return a view of the specified range within this list
	 * @throws IndexOutOfBoundsException if argument <code>fromIndex</code> is less than 0
	 * @throws IndexOutOfBoundsException if argument <code>toIndex</code> is greater than
	 * the size of this list
	 * @throws IndexOutOfBoundsException if argument <code>fromIndex</code> is greater than
	 * <code>toIndex</code>
	 */
	function subList(fromIndex:uint, toIndex:uint):IList;
	
	/**
	 * Removes all values from this list.
	 */
	function clear():void;
	
	/**
	 * Returns the number of added values.
	 * 
	 * @return the number of added values
	 */
	function size():uint;
	
	/**
	 * Returns whether this list is empty.
	 * 
	 * <p>This list is empty if it has no values assigned to it.</p>
	 * 
	 * @return <code>true</code> if this list is empty else <code>false</code>
	 */
	function isEmpty():Boolean;
	
	/**
	 * Returns the iterator to iterate over this list.
	 * 
	 * @return the iterator to iterate over this list
	 */
	function iterator():IIterator;
	
	/**
	 * Returns the index of <code>value</code>.
	 * 
	 * @param value the value to return the index of
	 * @return the index of <code>value</code>
	 */
	function indexOf(value:*):int;
	
	/**
	 * Returns the array representation of this list.
	 * 
	 * @return the array representation of this list
	 */
	function toArray():Array;

}
	
}