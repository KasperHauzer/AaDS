using System;
using System.Diagnostics;

namespace FirstLab
{
    /// <summary>
    /// Данный класс содержит конструктивную часть лабораторной работы №1. 
    /// </summary>
    public static class Model
    {
        /// <summary>
        /// Оповещает о том, что стек вызовов был переполнен, описание передается как первый аргумент.
        /// </summary>
        public static event Action<Object, EventArgs> DetectedDangerNumber;

        /// <summary>
        /// Находим x(n)-й элемент при помощи функции.
        /// </summary>
        /// <returns>x(n)-й элемент.</returns>
        /// <param name="n">Порядковый номер искомого элемента (начинается с 0).</param>
        public static (Int32 answer, TimeSpan delay, Boolean good) SolveFunctionaly(Int32 n)
        {
            Stopwatch stopwatch = new Stopwatch();

            stopwatch.Start();
            Int32 answer = (9 * n - 4) * (Int32)Math.Pow(-1, n) + 3 * n + 3;
            stopwatch.Stop();

            return (answer, stopwatch.Elapsed, true);
        }

        /// <summary>
        /// Находит x(n)-ый элемент итерационно.
        /// </summary>
        /// <returns>x(n)-ый элемент.</returns>
        /// <param name="n">Порядковый номер искомого элемента (начинается с 0).</param>
        public static (Int32 answer, TimeSpan delay, Boolean good) SolveIteratively(Int32 n)
        {
            Stopwatch stopwatch = new Stopwatch();

            stopwatch.Start();
            Int32 zero = -1;
            Int32 first = 1;
            Int32 current = default(Int32);

            for (Int32 i = 2; i <= n; i++) {
                current = 12 * i - 2 * first - zero;
                zero = first;
                first = current;
            }
            stopwatch.Stop();

            if (n == 0) return (zero, stopwatch.Elapsed, true);
            if (n == 1) return (first, stopwatch.Elapsed, true);
            return (current, stopwatch.Elapsed, true);
        }

        /// <summary>
        /// Находит x(n)-ый элемент рекурсивно.
        /// </summary>
        /// <returns>x(n)-ый элемент.</returns>
        /// <param name="n">Порядковый номер искомого элемента (начинается с 0).</param>
        public static (Int32 answer, TimeSpan delay, Boolean good) SolveRecursively(Int32 n)
        {
            Int32 maxN = 5500;
            if (n >= maxN) {
                OnDetectedDangerNumber("Рекурсивный подсчет был отменен из-за вероятности " +
                                       $"\n\tпереполнения стека вызовов (n >= {maxN}).");
                return default((Int32, TimeSpan, Boolean));
            }

            Stopwatch stopwatch = new Stopwatch();
            Int32 answer = default(Int32);

            stopwatch.Start();
            answer = RunRecursion(2, n, 0, 1, -1);
            stopwatch.Stop();

            return (answer, stopwatch.Elapsed, true);

        }

        /// <summary>
        /// Рекурсивно подсчитывает x(n)-й эемент.
        /// </summary>
        /// <returns>x(n)-й эемент.</returns>
        /// <param name="i">Номер текущего подсчитываемого элемента.</param>
        /// <param name="number">Номер требуемого элемента.</param>
        /// <param name="current">Текущий элемент.</param>
        /// <param name="previous">Предыдущий элемент.</param>
        /// <param name="superPrevious">Очень предыдущий элемент (дважды предыдущий).</param>
        static Int32 RunRecursion(Int32 i, Int32 number, Int32 current, Int32 previous, Int32 superPrevious)
        {
            if (number == 0) return superPrevious;
            if (number == 1) return previous;

                current = 12 * i - 2 * previous - superPrevious;
            return i == number ?
                current :
                RunRecursion(++i, number, 0, current, previous);
        }

        /// <summary>
        /// Проверяет число подписчиков события, и если есть хотя бы 1 подписчик
        /// вызывает подписанный на событие метод.
        /// </summary>
        static void OnDetectedDangerNumber(String description)
        {
            DetectedDangerNumber?.Invoke(description, new EventArgs());
        }
    }
}