

html{
    <ChildComponent>
        <template #header>
            <h1>Header slot content</h1>
        </template>
        <template #footer>
            <h2>Footer slot content</h2>
        </template>

        <input type="text" [(value)]={inputValue} />
    </ChildComponent>
}