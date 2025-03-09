using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace Cinemachine
{
    [DocumentationSorting(100, DocumentationSortingAttribute.Level.UserRef)]
    [AddComponentMenu("")] // Don't display in add component menu
    [RequireComponent(typeof(CinemachinePipeline))]
    [SaveDuringPlay]
    public class CinemachineTransposerDollyCart : CinemachineTransposer
    {
        
    }
}
