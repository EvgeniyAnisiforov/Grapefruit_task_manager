import './App.css'
import {Route, Routes } from "react-router-dom"
import RequiredAuth from './components/hoc/RequireAuth.tsx'
import {Auth} from "./pages/Auth.tsx"
import { Reg } from './pages/Reg.tsx'
import { Kanban } from './pages/Kanban.tsx'
import { NotFound } from './pages/NotFound.tsx'


function App() {

  return (
    <Routes>
        <Route path="/" element={<Auth />} />
        <Route path="/reg" element={<Reg />} />
        <Route path="/kanban" element={
          <RequiredAuth>
            <Kanban />
          </RequiredAuth>
          } />
        <Route path="*" element={<NotFound />} />
      </Routes>
  )
}

export default App
