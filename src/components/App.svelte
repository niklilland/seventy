<div class="wrapper">
  <header>
    <h1>Seventy</h1>
  </header>
  <main>
    <div class="left-gutter">
    </div>
    <div class="center">
      <div class="input-wrapper">
        <BookChapterInput on:selected={loadVerses} />
      </div>

      <!-- TODO: At a later time, add a list of numbers for each verse in selected chapter.
                 Clicking on a verse number jumps to that verse on the page and expands it. -->
      
      <!-- TODO: All verses for the specified chapter -->
      <ChapterContents {book} {chapter} />


    </div>
    <div class="right-gutter">
    </div>
  </main>
  <footer>
    <!-- TODO: Footer -->
  </footer>
</div>

<script>
  import 'bulma/css/bulma.css';
  import BookChapterInput from './BookChapterInput.svelte';
  import ChapterContents from './ChapterContents.svelte';

  let book = null;
  let chapter = null;

  function loadVerses({ detail }) {
    book = detail.book;
    chapter = detail.chapter;
  }

  export let name;
</script>

<style>
  .wrapper {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }

  header {
    background-color: #03aaaa;
    min-height: 50px;
  }
  h1 {
    font-size: 30px;
    margin-top: 3px;
    margin-left: 15px;
    color: white;
    padding-left: 5px;
  }
  main {
    background-color: white;
    flex: 1;
    display: flex;
    flex-direction: row;
  }
  footer {
    /* background-color: lightgreen; */
    height: 50px;
  }
  .left-gutter {
    width: 8%;
    /* background-color: #fc0283; */
  }
  .right-gutter {
    width: 8%;
    /* background-color: #f802fc; */
  }
  .center {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }

  .input-wrapper {
    margin-top: 5%;
    margin-left: auto;
    margin-right: auto;
    width: 90%;
  }
</style>
