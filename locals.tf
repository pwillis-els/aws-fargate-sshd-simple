locals {

    # Default to an ECR image
    container_image = length(var.container_image) > 0 ? var.container_image : "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_container}"

    container_taskdef  = <<TASKDEF
[
    {
        "command": [
            "/bin/sh", "-c", "curl -o /tmp/sshd-entrypoint.sh ${var.sshd_entrypoint_remote_script} \u0026\u0026 chmod 755 /tmp/sshd-entrypoint.sh \u0026\u0026 /tmp/sshd-entrypoint.sh"
        ],
        "cpu": 0,
        "entryPoint": [],
        "environment": [
            {
                "name": "SSHD_PORT",
                "value": "${var.container_port}"
            },
            {
                "name": "SSH_AUTHORIZED_KEY",
                "value": "${var.ssh_public_key}"
            }
        ],
        "essential": true,
        "image": "${local.container_image}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.cluster_name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "mountPoints": [
            {
                "containerPath": "/home/deploy/persist",
                "sourceVolume": "bastion-persist-volume"
            }
        ],
        "name": "bastion-container",
        "portMappings": [
            {
                "containerPort": ${var.container_port},
                "hostPort": ${var.container_port},
                "protocol": "tcp"
            }
        ],
        "volumesFrom": []
    }
]
TASKDEF

}
