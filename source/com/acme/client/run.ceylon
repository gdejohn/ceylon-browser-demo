import ceylon.interop.browser.dom {
    document,
    Event,
    EventListener
}

"Run the module `com.acme.client`."
shared void run() {
    value listener = object satisfies EventListener {
        shared actual void handleEvent(Event event) {
            value task = document.createElement("li");
            dynamic input = document.getElementById("task");
            dynamic {
                task.textContent = input.\ivalue;
                input.\ivalue = null;
            }
            value delete = document.createElement("button");
            delete.textContent = "Delete";
            delete.addEventListener(
                "click",
                object satisfies EventListener {
                    handleEvent(Event event) => task.remove();
                }
            );
            task.appendChild(delete);
            document.getElementById("tasks")?.appendChild(task);
            dynamic {
                input.focus();
            }
        }
    };
    document.getElementById("add")?.addEventListener("click", listener);
}
