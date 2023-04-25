js {
    // here will be logic

    (count = 0) => {
        increment = () => count += 1
        decrement = () => count -= 1
    }

    goHome = () => {
        router.go('Home')
    }

    //or goHome = router.go('Home')
}

html {
    <nav>
        <ul>
            <li @click=goHome() class=home >Home</li>
            <li>About</li>
            <ul>
                {items.map(item => (
                    <li class={item.active ? 'active' : ''}>{item.name}</li>
                ))}
            </ul>
        </ul>
    </nav>
    <CustomComponent @customEvent={handleCustomEvent} />
}

style {
    // here will be style scoped to just this component
    ul{
        width: 100%

        // comments here will be available as well
        // li is scoped to this component (file) and is scoped to ul
        // which means is compiled to ul li {}
        li {
            background-color: grey;
            // you can both end nl css with ; or just new line
        }
    }
}