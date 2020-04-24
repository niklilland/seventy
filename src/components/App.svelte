<div class="wrapper">
  <header>
    <h1>
      Seventy
    </h1>
  </header>
  <main>
    <div class="left-gutter">
    </div>
    <div class="center">
      <VerseInput />
      <WordSelector />
      <!-- TODO: Selected word Strong's definition -->
      <!-- TODO: Matches for word: OT verses that match the selected word -->
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
  import VerseInput from './VerseInput.svelte';
  import WordSelector from './WordSelector.svelte'

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
    height: 50px;
  }
  h1 {
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
    background-color: lightgreen;
    height: 50px;
  }
  .left-gutter {
    width: 8%;
    background-color: #fc0283;
  }
  .right-gutter {
    width: 8%;
    background-color: #f802fc;
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
</style>
