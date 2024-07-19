import { FC, useState } from "react"
import { useNavigate } from "react-router-dom"
import { useForm, SubmitHandler } from "react-hook-form"
import { usePostRegMutation } from "../redux/API/RegApi"
import ModalWindow from "../components/ModalWindow"
import WrapperCaptcha from "../components/Captcha/WrapperCaptcha"
import InputValidation from "../components/InputValidation"
import { useAppSelector } from "../redux/hook"

type PasswordDataType = {
  name: string
  surname: string
  login: string
  passwd: string
}

const Reg: FC<{}> = () => {
  const [reg] = usePostRegMutation()
  const color = useAppSelector(state=>state.themeColor.value)
  const navigate = useNavigate()
  const goAuth = () => navigate("/")
  const [visibleCaptcha, setVisibleCaptcha] = useState<boolean>(false)
  const [victoryCaptcha, setVictoryCaptcha] = useState(false)

  const {
    control,
    reset,
    formState: { errors },
    handleSubmit,
  } = useForm<PasswordDataType>()

  const onSubmit: SubmitHandler<PasswordDataType> = async (data) => {
    if(!victoryCaptcha){
      setVisibleCaptcha(true)
    }
    else{
      try{
        const result = await reg({name: data.name, surname: data.surname, login: data.login, passwd: data.passwd}).unwrap()
        if(result){
          goAuth()
        }
      }catch (errors){
        console.log("ошибка")
      }
      reset()
    }
  }

  return (
    <div className="w-screen h-screen">
      <div className={`w-full h-full ${color} flex justify-center items-center`}>
        <div className="pb-[100px]">
          <h1 className="text-5xl text-white max-[1500px]:text-4xl max-[400px]:text-3xl">
            Регистрация
          </h1>
          <form
            onSubmit={handleSubmit(onSubmit)}
            className="mt-5 w-full flex flex-col justify-center items-center"
          >
            <InputValidation control={control} errors={errors} nameTask="name" message="Имя" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.name ? "border-red-500" : ""
                  }`}/>
            <InputValidation control={control} errors={errors} nameTask="surname" message="Фамилия" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.name ? "border-red-500" : ""
                  }`}/>
            <InputValidation control={control} errors={errors} nameTask="login" message="Логин" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.name ? "border-red-500" : ""
                  }`}/>
            <InputValidation control={control} errors={errors} nameTask="passwd" message="Пароль" style={`m-2 w-[450px] h-12 rounded-xl max-[1500px]:w-[400px] max-[450px]:w-[350px] max-[400px]:w-[300px] ${
                    errors.name ? "border-red-500" : ""
                  }`}/>
            <div className="mt-3">
              <a
                onClick={goAuth}
                className="cursor-pointer hover:underline hover:text-blue-400 text-white text-2xl max-[1500px]:text-xl max-[400px]:text-lg"
              >
                Вернуться назад?
              </a>
            </div>
            <button
              type="submit"
              className="bg-yellow-400 rounded-xl mt-5 px-3 py-1 text-white text-3xl shadow-[0_0_10px_rgb(250_204_21)] hover:bg-yellow-500 transition duration-300 ease-in-out focus:outline-none max-[1500px]:text-2xl"
            >
              Войти
            </button>
          </form>
        </div>

        {visibleCaptcha && (
          <ModalWindow
            onClick={() => setVisibleCaptcha(false)}
            width="w-[700px]"
            height="h-[700px]"
            items="items-center"
          >
            <WrapperCaptcha closeCaptcha={()=>setVisibleCaptcha(false)} victoryCaptcha={()=> setVictoryCaptcha(true)}/>
          </ModalWindow>
        )}
      </div>
    </div>
  )
}
export { Reg }
