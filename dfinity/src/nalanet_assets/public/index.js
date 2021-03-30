import nalanet from 'ic:canisters/nalanet';

nalanet.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
