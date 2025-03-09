using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine.Profiling;

namespace LuaTools
{
    public static class LuaProfiler
    {
        private static int sampleDepth;
        private static readonly Dictionary<int, string> showNames = new Dictionary<int, string>();

        [Conditional("UNITY_EDITOR")]
        public static void BeginSample(int id)
        {
            string name;
            showNames.TryGetValue(id, out name);
            name = name ?? string.Empty;

            Profiler.BeginSample(name);
            ++sampleDepth;
        }

        [Conditional("UNITY_EDITOR")]
        public static void BeginSample(int id, string name)
        {
            name = name ?? string.Empty;
            showNames[id] = name;

            Profiler.BeginSample(name);
            ++sampleDepth;
        }

        [Conditional("UNITY_EDITOR")]
        internal static void BeginSample(string name)
        {
            name = name ?? string.Empty;
            Profiler.BeginSample(name);
            ++sampleDepth;
        }

        [Conditional("UNITY_EDITOR")]
        public static void EndSample()
        {
            if (sampleDepth > 0)
            {
                --sampleDepth;
            }
            Profiler.EndSample();
        }
    }
}