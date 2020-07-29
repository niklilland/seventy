<div class="wrapper">
  <!-- Two columns: small column for verse number & big column for text -->
  <div class="reference">
    <b>{reference.verse}</b>
  </div>
  <div class="text">
    {reference.text}
  </div>
</div>

<script>

export let reference;
</script>

<style>
.wrapper {
  display: flex;
  flex-direction: row;
  margin: 10px 20px;
}
.reference {
  min-width: 30px;
}
.text {
  
}
</style>