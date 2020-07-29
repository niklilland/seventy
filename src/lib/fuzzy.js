// import levenshtein from 'levenshtein-edit-distance';
// import { AllBooksNoNumbers } from '../constants';

// // Returns the closest book to the inputted book according to the levenshtein algorithm
// function closestBook(inputBook) {
//   // If there's a direct match, return it
//   const index = AllBooksNoNumbers.indexOf(inputBook);
//   if (index != -1) return AllBooksNoNumbers[index];

//   // Otherwise, invoke the levenshtein algorithm to return the closest book
//   const matches = AllBooksNoNumbers.map(book => levenshtein(inputBook, book));
//   return AllBooksNoNumbers[lowestIndex(matches)];
// }

// // Returns the index of the lowest value in the array
// function lowestIndex(array) {
//   // Set lowest to the first value in the array
//   let lowest = array[0];
//   // Iterate over array and find the lowest value
//   for (let i = 0; i < array.length; i++) {
//     if (array[i] < lowest) lowest = array[i];
//   }
//   return array.indexOf(lowest);;
// }

// export { closestBook };