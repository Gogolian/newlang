import { Navbar } from "./components/Navbar/Navbar.newlang"
import { Footer } from "./components/Footer/Footer.newlang"

component App {
    html {
        <Navbar />
        <router-outlet />
        <Footer />
    }
}
