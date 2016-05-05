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
            }
            value tasks {
                if (exists tasks = document.getElementById("tasks")) {
                    return tasks;
                }
                else {
                    value tasks = document.createElement("ol");
                    tasks.id = "tasks";
                    assert (exists todos = document.getElementById("todos"));
                    todos.appendChild(tasks);
                    return tasks;
                }
            }
            tasks.appendChild(task);
        }
    };
    document.getElementById("add")?.addEventListener("click", listener);
}
