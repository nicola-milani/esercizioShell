//prova originale due label
document.addEventListener("animationstart", changeStartLabel);
document.addEventListener("animationend", changeEndLabel);
document.addEventListener("animationend", onclickBubbleBtn);

function changeStartLabel(){
    var startButton = document.querySelector(".one-page-cover__start-link");
    startButton.setAttribute("aria-label","Inizio");
    console.log("funziona Start");
    document.removeEventListener("animationstart", changeStartLabel);
}

function changeEndLabel(){
    var replayButton = document.querySelector(".blocks-lesson-restart-button");
        replayButton.setAttribute("aria-label","Ricomincia");
    console.log("funziona Replay");
    document.removeEventListener("animationend", changeEndLabel);
}

function onclickBubbleBtn(){
    var btnBubble = document.getElementsByClassName("labeled-graphic-marker");
    console.log(btnBubble);
    var btnBubbleLenght = btnBubble.length;
    var setOnClickButtons;
    btnBubble.forEach((element) => {
    element.setAttribute("onclick", "changeBubbleArialabel()");
    console.log("messo onclick su bubble")
    setOnClickButtons++;
    });
    if (setOnClickButtons = btnBubbleLenght){
        document.removeEventListener("animationend", onclickBubbleBtn)
    }
}

function changeBubbleArialabel(){
    var bubbles = document.querySelector(".bubble__body");
    bubbles.setAttribute("aria-label","fumetto in sopraimpressione");
    console.log("cambiata label");

}


//test per attivare i listener uno alla volta (problema con il replay, da capire perchè)
/*document.addEventListener("animationstart", changeStartLabel);

function changeStartLabel(){
    var startButton = document.querySelector(".one-page-cover__start-link");
    startButton.setAttribute("aria-label","Inizio");
    console.log("funziona Start");
    startButton.setAttribute("onclick", "listenerEndLabel()");
    console.log("add onlick Start")
    document.removeEventListener("animationstart", changeStartLabel);
}


function listenerEndLabel(){
    document.addEventListener("animationend", changeEndLabel);
    console.log("listner End")
}

function changeEndLabel(){
    console.log("entrato in replay");
    var replayButton = document.querySelector(".blocks-lesson-restart-button");
        replayButton.setAttribute("aria-label","Ricomincia");
    console.log("funziona Replay");
    document.removeEventListener("animationend", changeEndLabel);
}*/

//test per usare l'osservazione delle modifiche del DOM (non riuscito, riprovare)
/*const targetNode = document.getElementsByTagName("body")[0];
const config = {childList: true, subtree: true};

const callback = (mutationList, observer) => {
    for (const mutation of mutationList) {
        if (mutation.type === "subtree") {
          console.log("A subtree node has been added or removed.");
        } else if (mutation.type === "attributes") {
          console.log(`The ${mutation.attributeName} attribute was modified.`);
        }
      }
    };
    
    // Create an observer instance linked to the callback function
    const observer = new MutationObserver(callback);
    
    // Start observing the target node for configured mutations
    observer.observe(targetNode, config);
    
    // Later, you can stop observing
    observer.disconnect();*/