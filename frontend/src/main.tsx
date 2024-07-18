import ReactDOM from "react-dom/client"
import { BrowserRouter } from "react-router-dom"
import { Provider } from "react-redux"
import {PersistGate} from "redux-persist/integration/react"
import store, { persistor } from "./redux/index.ts"
import App from "./App.tsx"
import "./index.css"

ReactDOM.createRoot(document.getElementById("root")!).render(
  <BrowserRouter basename="/Grapefruit_task_manager/">
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <App />
      </PersistGate>
    </Provider>
  </BrowserRouter>
)
