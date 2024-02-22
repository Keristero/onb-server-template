return {
    global_object = '',
    description = 'used by keyframe details, you can specify hardcoded values for the keyframe, if no X,Y,Z is specified, it will use the x,y,z of this node.',
    handlers = {
        [1]={
            name='Animation',
            type='string'
        },
        [2]={
            name='Animation Speed',
            type='string'
        },
        [3]={
            name='X',
            type='float',
        },
        [4]={
            name='Y',
            type='float',
        },
        [5]={
            name='Z',
            type='float',
        },
        [6]={
            name='ScaleX',
            type='float'
        },
        [7]={
            name='ScaleY',
            type='float'
        },
        [8]={
            name='Rotation',
            type='float'
        },
        [9]={
            name='Direction',
            type='string',
            enum='Direction'
        },
        [10]={
            name='Sound Effect',
            type='string'
        },
        [11]={
            name='Sound Effect Loop',
            type='boolean'
        }
    }
}