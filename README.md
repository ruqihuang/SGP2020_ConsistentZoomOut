# Consistent ZoomOut
This is a demo of the method described in paper 'Consistent ZoomOut: Efficient Spectral Map Synchronization' (SGP 2020). 
In particular, we consider the *Fourleg* class (20 shapes) from SHREC07 dataset. The initial maps are computed via [BIM method](http://www.vovakim.com/projects/CorrsBlended/), then we apply our Consistent ZoomOut for map synchronization.

**Dependency**

The implementation depends on [CVX](http://cvxr.com/cvx/). 

**Instruction**

Please first unzip the files (meshes and initial maps) in './data/', then simply run 'demo.m' in the main folder. In the end, you can visualize and compare the initial maps and our results. 

**Contact**

Please let us know (rqhuang88 At gmail Dot com) if you have any question about this demo.

**Citation**

If you use this code, please cite our paper:)
```
@inproceedings{CZO_SGP20,
    title={Consistent ZoomOut: Efficient Spectral Map Synchronization}, 
    author={Ruqi Huang and Jing Ren and Peter Wonka and Maks Ovsjanikov},
    booktitle={Proc. SGP},
    volume={39},
    name={5},
    year={2020},
}
```


