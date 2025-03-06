#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <keyword> <desired_capacity>"
    echo "Example: $0 my-asg 0"
    exit 1
fi

KEYWORD=$1
DESIRED_CAPACITY=$2

# Validate desired_capacity is either 0 or 1
if [ "$DESIRED_CAPACITY" -ne 0 ] && [ "$DESIRED_CAPACITY" -ne 1 ]; then
    echo "Desired capacity must be either 0 or 1"
    exit 1
fi

# Function to find and update ASG
update_asg() {
    local keyword=$1
    local capacity=$2
    
    # Search for ASG with the keyword
    ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
        --query "AutoScalingGroups[?contains(AutoScalingGroupName, \`$keyword\`)].AutoScalingGroupName" \
        --output text)

    if [ -z "$ASG_NAME" ]; then
        echo "No Auto Scaling Group found with keyword: $keyword"

	aws autoscaling describe-auto-scaling-groups 
	
        exit 1
    fi

    # If multiple ASGs match, take the first one
    FIRST_ASG=$(echo "$ASG_NAME" | head -n 1)
    
    echo "Found Auto Scaling Group: $FIRST_ASG"

    # Update the ASG desired capacity
    aws autoscaling update-auto-scaling-group \
        --auto-scaling-group-name "$FIRST_ASG" \
        --desired-capacity "$capacity"
    
    if [ $? -eq 0 ]; then
        echo "Successfully set desired capacity to $capacity for $FIRST_ASG"
    else
        echo "Failed to update Auto Scaling Group"
        exit 1
    fi
}

# Execute the update
update_asg "$KEYWORD" "$DESIRED_CAPACITY"
