<div class="reference-controls">
  <AutoComplete className="book-input"
                items={AllBooks}
                bind:selectedItem={selectedBook}
                placeholder="Select a book"
                onChange={bookChange} />
  <AutoComplete className="chapter-input"
                disabled={!selectedBook}
                items={chapters}
                placeholder="Select a chapter"
                onChange={chapterChange}
                bind:selectedItem={selectedChapter} />
</div>

<script>
  import { createEventDispatcher } from 'svelte';
  import { Button } from 'svelma';
  import AutoComplete from "simple-svelte-autocomplete";
  import { AllBooks, ChapterReference } from '../constants';

  const dispatch = createEventDispatcher();

  let selectedBook;
  let selectedChapter;
  let chapters = [];

  function bookChange(value) {
    chapters = [];
    for (let i = 1; i <= ChapterReference[value]; i++) {
      chapters.push(i);
    }
  }

  function chapterChange(value) {
    dispatch('selected', { book: selectedBook, chapter: value });
  }
</script>

<style>
  .reference-controls {
    align-self: center;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
  }
</style>
