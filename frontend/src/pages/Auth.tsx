import { FC } from "react"
import { useNavigate } from "react-router-dom"
import { usePostAuthMutation } from "../redux/API/AuthApi"
import { useForm, SubmitHandler } from "react-hook-form"
import { useAppDispatch } from "../redux/hook"
import { setStatusAuth } from "../redux/statusAuth-slice"
import InputValidation from "../components/InputValidation"

interface LoginDataType {
  login: string
  password: string
}

const Auth: FC<{}> = () => {
  const dispatch = useAppDispatch()
  const [login] = usePostAuthMutation()

  const navigate = useNavigate()

  const goReg = () => navigate("/reg")
  const goKanban = () => navigate("/kanban")


  const {
    control,
    reset,
    formState: { errors },
    handleSubmit,
  } = useForm<LoginDataType>()

  const onSubmit: SubmitHandler<LoginDataType> = async (data) => {
    try {
      const result = await login({
        login: data.login,
        passwd: data.password,
      }).unwrap()
      if (result) {
        const { id, name, surname } = result
        dispatch(
          setStatusAuth({ status: true, id: id, name: name, surname: surname })
        )
        goKanban()
      }
    } catch (errors) {
      console.log("ошибка")
    }
    reset()
  }

  return (
    <div className="w-screen h-screen">
      <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500 flex justify-center items-center">
        <div className="pb-[100px]">
          <h1 className="text-5xl text-white max-[1500px]:text-4xl max-[400px]:text-3xl">
            Авторизация
          </h1>
          <form
            onSubmit={handleSubmit(onSubmit)}
            className="mt-5 w-full flex flex-col justify-center items-center"
          >
            <InputValidation control={control} errors={errors} nameTask="login" message="Логин" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.login ? "border-red-500" : ""
                  }`}/>
            <InputValidation control={control} errors={errors} nameTask="password" message="Пароль" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.login ? "border-red-500" : ""
                  }`}/>
            <p className="text-white mt-3 text-2xl max-[1500px]:text-xl max-[400px]:text-lg">
              У вас нет аккаунта?{" "}
              <a
                onClick={goReg}
                className="cursor-pointer hover:underline hover:text-blue-400"
              >
                Регистрация
              </a>
            </p>
            <button
              type="submit"
              className="bg-yellow-400 rounded-xl mt-5 px-3 py-1 text-white text-3xl shadow-[0_0_10px_rgb(250_204_21)] hover:bg-yellow-500 transition duration-300 ease-in-out focus:outline-none max-[1500px]:text-2xl"
            >
              Войти
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
export { Auth }
