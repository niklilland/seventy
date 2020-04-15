<div class="wrapper">
  <header>
    <h1>
      Seventy
    </h1>
  </header>
  <main>


  <!-- TODO: Verse picker -->
  <!-- TODO: String's definition -->
  <!-- TODO: Split pane -->
  <!-- TODO: Left pane: Matches in OT -->
  <!-- TODO: Right pane: OT verse based on left pane match selected -->




    <div class="left-gutter">
      <NewTestamentViewer />
    </div>
    <div class="center">
      <!-- TODO: Center -->
    </div>
    <div class="right-gutter">
      <!-- TODO: Right gutter -->
    </div>
  </main>
  <footer>
    <!-- TODO: Footer -->
  </footer>
</div>



<script>
  import NewTestamentViewer from './NewTestament.svelte';

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
    width: 33.33%;
    background-color: #fc0283;
  }
  .right-gutter {
    width: 33.33%;
    background-color: #f802fc;
  }
  .center {
    flex: 1;
  }
  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
