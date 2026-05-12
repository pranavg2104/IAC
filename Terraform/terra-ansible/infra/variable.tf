locals {
  enviornment = {
    dev = 2
    prod = 2
    stage = 2
  }

  instances = flatten([
    for env, count in local.enviornment :[
        for i in range (count):{
            name = "${env}-${i+1}"
            env = env
        }
    ]
  ])
}