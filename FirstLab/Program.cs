using System;
using System.Threading.Tasks;

namespace FirstLab
{
    class Program
    {
        static void Main()
        {
            Console.Title = "Лабораторная работа №1";

            //Подписываем метод на событие "Обнаружено опасное число" класса Model,
            //так как рекурсивный метод переполняет стек вызовов.
            Model.DetectedDangerNumber += ShowWarning;

            do {
                //Просим пользователя ввести число до тех пор, пока он не введет целое число
                //больше -1. Переменную "n" передаем в методы для подсчета x(n)-го элемента 
                //последовательности. 
                Int32 n = 0;
                Console.Write("Введите целое число: ");
                while (!Int32.TryParse(Console.ReadLine(), out n) || n < 0)
                    Console.Write("Введите целое число (>= 0): ");

                //Сообщаем пользователю о том, что процес поддсчета x(n)-го элемента начат, 
                //и меняем цвет шрифта для выделения результатов.
                Console.WriteLine("\n<Процесс начат>");
                Console.ForegroundColor = ConsoleColor.Magenta;

                //Подсчет функцией.
                Task solveByFunc = Task.Factory.StartNew(delegate
                {
                    var a = Model.SolveFunctionaly(n);
                    ShowResult("Функция", a);
                });

                //Подсчет в цикле.
                Task solveByIteration = Task.Factory.StartNew(delegate
                {
                    var a = Model.SolveIteratively(n);
                    ShowResult("Цикл", a);
                });

                //Подсчет рекурсивно.
                Task solveByRecursion = Task.Factory.StartNew(delegate
                {
                    var a = Model.SolveRecursively(n);
                    ShowResult("Рекурсия", a);
                });

                //На данном этапе мы должно дождаться выполнения всех трех фоновых потоков,
                //для того, чтобы после их заверщшения сообщить пользователю о том, что подсчет
                //завершен. 
                solveByFunc.Wait();
                solveByIteration.Wait();
                solveByRecursion.Wait();

                //Меняем цвет консоли на стандартный и сообщает пользователю о том, что подсчет
                //x(n)-го элемента завершен.
                Console.ForegroundColor = ConsoleColor.Black;
                Console.WriteLine("\n<\\Процесс завершен>\n");

                //Даный цикл выполняется бесконечно для того, чтобы программа не прекращала свою
                //работу до тех пор, пока пользователь не закрое ее самостоятельно. 
            } while (true);
        }

        /// <summary>
        /// Показывает результат работы методов для подсчета x(n)-го элемента последовательности.
        /// </summary>
        /// <param name="config">Метод для подсчета x(n)-го элемента последовательности.</param>
        /// <param name="typle">Картеж, который содержит ответ и интервал времени, который затратил метод на подсчет ответа.</param>
        static void ShowResult(String config, (Int32 answer, TimeSpan delay, Boolean good) typle)
        {
            if (!typle.good) return;

            //Если задержка меньше милисекунды, то выводим число тактов, иначе милисекунды.
            String time = typle.delay.Milliseconds < 1 ?
                               typle.delay.Ticks + " тк" :
                               typle.delay.Milliseconds + " мс";

            //Составляем строку из входных параметров для вывода на консоль и выводим ее.
            String showingString = $"\n\t{config}.\n\tОтвет: {typle.answer}\n\tВремя: {time}";
            Console.WriteLine(showingString);
        }

        /// <summary>
        /// Выводит сообщение о том, что входные данные могу повлечь переполнение стека.
        /// </summary>
        static void ShowWarning(Object source, EventArgs e)
        {
            Console.WriteLine($"\n\t{source}");
        }
    }
}
