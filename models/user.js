const mongoose = require('mongoose')

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true
    },
    phone: {
        type: String
    },
    username: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    }, 
    verified: {
        type: Boolean,
        default: 0
    }, 
    status: {
        type: Boolean,
        default: 0
    },
    userDetails: {
        firstName: {
            type: String,
        },
        lastName: {
            type: String,
        },
        profession: {
            type: String,
        },
        age: {
            type: Number,
        },
        address: {
            line1: {
                type: String,
            },
            line2: {
                type: String,
            },
            city: {
                type: String,
            },
            country: {
                type: String,
            },
          pincode: {
                type: String,
            }
        }
    },
    heartCoinsDetails: [{
        heartCoins: {
            type: Number,
            required: true
        },
        postID: {
            type: mongoose.Schema.Types.ObjectId,
            required: true
        },
        feedback: {
            type: String,
        }
    }]
});

module.exports = mongoose.model('user', userSchema, 'user');
