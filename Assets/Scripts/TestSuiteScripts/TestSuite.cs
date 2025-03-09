using System.Reflection;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 单元测试类，主要是用于测试一些CS这边的代码
/// </summary>
public class TestSuite : MonoBehaviour
{   
    /// <summary>
    /// 主函数，获取所有的带有标记特性的函数，并且创建按钮
    /// </summary>
    public void DisplayTaggedMethods()
    {
        List<MethodInfo> methods = _get_all_tagged_methods();
        _draw_all_buttons(methods);
    }    

    public List<MethodInfo> _get_all_tagged_methods()
    {
        System.Type t = this.GetType();
        MethodInfo[] methods = t.GetMethods();
        List<MethodInfo> ret = new List<MethodInfo>(methods.Length);
        foreach (MethodInfo single_method in methods)
        {
            if (!single_method.IsPublic)
                continue;

            TestSuiteMethod attr = single_method.GetCustomAttribute<TestSuiteMethod>();
            if (null == attr)
                continue;

            ret.Add(single_method);
        }

        return ret;
    }

    public void _draw_all_buttons(List<MethodInfo> methods)
    {
        if (null == methods)
        {
            Debug.LogError("[TestSuite] methods got null");
            return;
        }

        foreach (MethodInfo method in methods)
        {
            if (!method.IsPublic)
                continue;

            TestSuiteMethod attr = method.GetCustomAttribute<TestSuiteMethod>();
            if (null == attr)
                continue;

            if (GUILayout.Button(attr.Name))
                method.Invoke(this, null);
        }
    }
}