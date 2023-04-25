component Counter {
    props {
        initialCount: Int
    }

    state {
        count: Int = initialCount
    }

    html {
        <div>
            <button onClick={decrement}>-</button>
            <span>{count}</span>
            <button onClick={increment}>+</button>
        </div>
    }

    methods {
        increment() {
            count += 1
        }

        decrement() {
            count -= 1
        }
    }
}
