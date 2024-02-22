return {
    global_object = '',
    description = 'used by keyframe details, you can specify hardcoded values for the keyframe, if no X,Y,Z is specified, it will use the x,y,z of this node.',
    arguments = {
        [1]={
            name='Animation',
            type='string',
            optional=true
        },
        [2]={
            name='Animation Speed',
            type='string',
            optional=true
        },
        [3]={
            name='X',
            type='float',
            optional=true
        },
        [4]={
            name='Y',
            type='float',
            optional=true
        },
        [5]={
            name='Z',
            type='float',
            optional=true
        },
        [6]={
            name='ScaleX',
            type='float',
            optional=true
        },
        [7]={
            name='ScaleY',
            type='float',
            optional=true
        },
        [8]={
            name='Rotation',
            type='float',
            optional=true
        },
        [9]={
            name='Direction',
            type='string',
            enum='Direction',
            optional=true
        },
        [10]={
            name='Sound Effect',
            type='string',
            optional=true
        },
        [11]={
            name='Sound Effect Loop',
            type='boolean',
            optional=true
        }
    }
}