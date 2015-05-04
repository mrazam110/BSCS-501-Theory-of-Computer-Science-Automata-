/*a^n b^m a^m b^n

<s> -> a<x>b
<x> -> a<x>b
<x> -> b<y>a
<y> -> b<y>a
<y> -> nil*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            char[] a = {'a', 'a', 'b', 'b', '$'};
            CFG c = new CFG("aabbabb$".ToCharArray());
            c.validate();
        }
    }

    class CFG {

        public static int index = 0;
        char[] ch;

        public CFG(char[] ch) {
            this.ch = ch;
        }

        public bool s() {
            if (ch[index] == 'a')
            {
                index++;

                if (s() == true)
                {

                    if (ch[index] == 'b')
                    {
                        index++;
                        return true;
                    }

                }
            }
            else {
                return true;
            }

            return false;
        }

        public bool validate() {

            if (s() == true) {
                if (ch[index] == '$') {

                    Console.Write("TRUE\n");
                    return true;
                }
            }
            Console.Write("FALSE\n");
            return false;
        }

    }

}
