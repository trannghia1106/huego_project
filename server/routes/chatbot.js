const express = require('express');
const router = express.Router();
const chatbotController = require('../controllers/chatbotController');

router.get('/suggestions', chatbotController.getSuggestions);
router.post('/ask', chatbotController.askChatbot);

module.exports = router;