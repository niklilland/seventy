<div>
  {#each chapterContents as reference}
    <EnglishVerse {reference} />
  {/each}
</div>

<script>
  import { createEventDispatcher, beforeUpdate } from 'svelte';
  import axios from 'axios';
  import EnglishVerse from './EnglishVerse.svelte';

  let chapterContents = [];

  let cacheBook;
  let cacheChapter;

  // before update, the component loads the file for the verse based on the book/chapter props
  beforeUpdate(() => {
    if (book && chapter && book !== cacheBook && chapter !== cacheChapter) {
      cacheBook = book;
      cacheChapter = chapter;
      // Remove spaces from book name, special handling for song of songs
      const bookName = book === 'Song of Solomon' ? 'SongOfSongs' : book.replace(' ', '');
      axios.get(`https://niklilland.github.io/bible-as-js/KJV/${bookName}/${chapter}.json`)
      .then(response => chapterContents = response.data);
    }
  });

  export let book;
  export let chapter;
</script>

<style>

</style>
