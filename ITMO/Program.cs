using System;
using System.IO;

namespace ITMO
{
    class Program
    {
        static readonly String fileIn = "input.txt";
        static readonly String fileOut = "output.txt";

        static void Main()
        {
            String[] text = File.ReadAllText(fileIn).Split(' ');
            Int64 a = Convert.ToInt64(text[0]);
            Int64 b = Convert.ToInt64(text[1]);

            Int64 c = a + b * b;
            File.WriteAllText(fileOut, c.ToString());
        }
    }
}
